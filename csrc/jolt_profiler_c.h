#pragma once

#include "joltc.h"

#ifdef __cplusplus
extern "C" {
#endif

/// One profiled scope, its samples for the current frame added up. Cycles are processor
/// ticks; divide by JPH_Profiler_GetProcessorTicksPerSecond for seconds.
typedef struct JPH_ProfilerSample {
	const char *name;
	uint32_t	callCount;
	uint64_t	totalCycles;
	uint64_t	maxCycles;
} JPH_ProfilerSample;

/// Whether the library was built with JPH_PROFILE_ENABLED. Everything below does nothing
/// and reports zero when it was not.
JPH_CAPI bool JPH_Profiler_IsAvailable(void);

JPH_CAPI bool JPH_Profiler_IsStarted(void);

/// Starts profiling and instruments the calling thread. There is deliberately no stop:
/// ProfileThread's destructor dereferences the profiler singleton, so destroying it while
/// a worker thread still holds instrumentation crashes that thread on its way out.
///
/// A thread is only instrumented if the profiler already existed when the thread started,
/// and Jolt's worker threads instrument themselves as they spawn. Start this before the
/// physics system is created to profile all of them; start it later and only the calling
/// thread is measured, which still sees the share of the physics jobs Jolt runs there.
JPH_CAPI void JPH_Profiler_Start(const char *threadName);

/// Ends the frame and clears every thread's samples, so read them before calling this.
JPH_CAPI void JPH_Profiler_NextFrame(void);

/// Writes Jolt's own HTML chart for every instrumented thread on the next NextFrame call.
JPH_CAPI void JPH_Profiler_Dump(const char *tag);

JPH_CAPI uint64_t JPH_Profiler_GetProcessorTicksPerSecond(void);

/// Aggregates the calling thread's samples by scope, largest total first. Only this
/// thread: the per-thread sample buffers other threads are still writing cannot be read
/// without a lock the profiler does not expose. Use the dump for a full picture.
JPH_CAPI uint32_t JPH_Profiler_GetCallingThreadSamples(JPH_ProfilerSample *outSamples, uint32_t maxCount);

#ifdef __cplusplus
}
#endif
