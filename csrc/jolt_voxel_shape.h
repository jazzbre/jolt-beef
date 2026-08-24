// Jolt Physics Library (https://github.com/jrouwe/JoltPhysics)
// SPDX-FileCopyrightText: 2026 Jorrit Rouwe
// SPDX-License-Identifier: MIT

#pragma once

// VoxelShape is declared next to this file, in csrc. It is compiled into the Jolt target
// by jolt_cmake.patch, which also puts this directory on Jolt's public include path, so
// the samples testbed and joltc both reach the same single copy. Keeping the source here
// rather than in the Jolt tree means resetting or cleaning that submodule cannot lose it.

#include "VoxelShape.h"
