// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

// C ABI for Jolt's built-in profiler. Jolt aggregates samples only inside DumpInternal
// and keeps the result private, so the per-scope readout here walks the calling thread's
// own sample buffer, which is public, and adds it up the same way.

#include <Jolt/Jolt.h>
#include <Jolt/Core/Profiler.h>

#include "jolt_profiler_c.h"

#ifdef JPH_PROFILE_ENABLED

namespace {

	// Jolt names scopes with string literals, so the pointer identifies the scope and the
	// text never has to be compared.
	constexpr uint32_t cMaxAggregatedScopes = 128;

	uint32_t FindOrAddScope(JPH_ProfilerSample *ioAggregates, uint32_t &ioCount, const char *inName)
	{
		for (uint32_t index = 0; index < ioCount; ++index)
			if (ioAggregates[index].name == inName)
				return index;

		if (ioCount == cMaxAggregatedScopes)
			return cMaxAggregatedScopes;

		JPH_ProfilerSample &aggregate = ioAggregates[ioCount];
		aggregate.name = inName;
		aggregate.callCount = 0;
		aggregate.totalCycles = 0;
		aggregate.maxCycles = 0;
		return ioCount++;
	}

}

#endif // JPH_PROFILE_ENABLED

bool JPH_Profiler_IsAvailable(void)
{
#ifdef JPH_PROFILE_ENABLED
	return true;
#else
	return false;
#endif
}

bool JPH_Profiler_IsStarted(void)
{
#ifdef JPH_PROFILE_ENABLED
	return JPH::Profiler::sInstance != nullptr;
#else
	return false;
#endif
}

void JPH_Profiler_Start(const char *inThreadName)
{
#ifdef JPH_PROFILE_ENABLED
	// JPH_PROFILE_START and JPH_PROFILE_THREAD_START name Profiler and ProfileThread
	// unqualified, so they only compile inside namespace JPH. This is what they do.
	const char *thread_name = inThreadName != nullptr ? inThreadName : "Main";
	if (JPH::Profiler::sInstance == nullptr)
		JPH::Profiler::sInstance = new JPH::Profiler;
	if (JPH::ProfileThread::sGetInstance() == nullptr)
		JPH::ProfileThread::sSetInstance(new JPH::ProfileThread(thread_name));
#else
	JPH_UNUSED(inThreadName);
#endif
}

void JPH_Profiler_NextFrame(void)
{
#ifdef JPH_PROFILE_ENABLED
	if (JPH::Profiler::sInstance != nullptr)
		JPH::Profiler::sInstance->NextFrame();
#endif
}

void JPH_Profiler_Dump(const char *inTag)
{
#ifdef JPH_PROFILE_ENABLED
	if (JPH::Profiler::sInstance != nullptr)
		JPH::Profiler::sInstance->Dump(inTag != nullptr ? JPH::string_view(inTag) : JPH::string_view());
#else
	JPH_UNUSED(inTag);
#endif
}

uint64_t JPH_Profiler_GetProcessorTicksPerSecond(void)
{
#ifdef JPH_PROFILE_ENABLED
	return JPH::Profiler::sInstance != nullptr ? JPH::Profiler::sInstance->GetProcessorTicksPerSecond() : 0;
#else
	return 0;
#endif
}

uint32_t JPH_Profiler_GetCallingThreadSamples(JPH_ProfilerSample *outSamples, uint32_t inMaxCount)
{
#ifdef JPH_PROFILE_ENABLED
	if (outSamples == nullptr || inMaxCount == 0 || JPH::Profiler::sInstance == nullptr)
		return 0;

	const JPH::ProfileThread *profile_thread = JPH::ProfileThread::sGetInstance();
	if (profile_thread == nullptr)
		return 0;

	JPH_ProfilerSample aggregates[cMaxAggregatedScopes];
	uint32_t aggregate_count = 0;

	uint32_t sample_count = JPH::min(uint32_t(profile_thread->mCurrentSample), uint32_t(JPH::ProfileThread::cMaxSamples));
	for (uint32_t sample_index = 0; sample_index < sample_count; ++sample_index)
	{
		const JPH::ProfileSample &sample = profile_thread->mSamples[sample_index];
		// A scope the calling thread is still inside has had its slot claimed but not
		// written. Callers read this between physics updates, where there are none.
		if (sample.mName == nullptr || sample.mEndCycle < sample.mStartCycle)
			continue;

		uint32_t aggregate_index = FindOrAddScope(aggregates, aggregate_count, sample.mName);
		if (aggregate_index == cMaxAggregatedScopes)
			continue;

		uint64_t cycles = sample.mEndCycle - sample.mStartCycle;
		aggregates[aggregate_index].callCount++;
		aggregates[aggregate_index].totalCycles += cycles;
		aggregates[aggregate_index].maxCycles = JPH::max(aggregates[aggregate_index].maxCycles, cycles);
	}

	for (uint32_t index = 1; index < aggregate_count; ++index)
	{
		JPH_ProfilerSample aggregate = aggregates[index];
		uint32_t insert_at = index;
		while (insert_at > 0 && aggregates[insert_at - 1].totalCycles < aggregate.totalCycles)
		{
			aggregates[insert_at] = aggregates[insert_at - 1];
			--insert_at;
		}
		aggregates[insert_at] = aggregate;
	}

	uint32_t copied = JPH::min(aggregate_count, inMaxCount);
	for (uint32_t index = 0; index < copied; ++index)
		outSamples[index] = aggregates[index];
	return copied;
#else
	JPH_UNUSED(outSamples);
	JPH_UNUSED(inMaxCount);
	return 0;
#endif
}
