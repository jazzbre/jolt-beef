@echo off
REM Both submodules are reset and pulled. The cd is checked: the Jolt submodule is called
REM JoltPhysics, and a cd that silently failed used to leave these commands running one
REM directory up, where they reset jolt-beef itself instead of the submodule.
REM Voxel support survives this: the shape source lives in csrc and the Jolt-side wiring is
REM re-applied from csrc\jolt_cmake.patch by build_windows_vs2022.cmd. Local edits inside
REM the submodules do not survive, so stash anything you want to keep before running this.

cd submodules || exit /b 1

cd JoltPhysics || exit /b 1
git reset --hard
git pull
cd ..

cd joltc || exit /b 1
git reset --hard
git pull
cd ..

cd ..

pause