.PHONY: all configure build clean rebuild debug run help

CMAKE = D:\msvsc\product\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe
NINJA = D:\msvsc\product\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe
CL_COMPILER = D:\msvsc\product\VC\Tools\MSVC\14.43.34808\bin\Hostx64\x64\cl.exe
VCPKG_ROOT = C:\vcpkg
BUILD_DIR = build\windows-release
BUILD_TYPE = RelWithDebInfo

all: build

configure:
	@echo "Configuring project (Release)..."
	@if exist "$(BUILD_DIR)" rmdir /S /Q "$(BUILD_DIR)"
	@mkdir "$(BUILD_DIR)"
	@set VCPKG_ROOT=$(VCPKG_ROOT) && $(CMAKE) -B $(BUILD_DIR) -G "Visual Studio 17 2022" -A x64 -DCMAKE_UNITY_BUILD=OFF -DCMAKE_TOOLCHAIN_FILE=$(VCPKG_ROOT)\scripts\buildsystems\vcpkg.cmake -DVCPKG_TARGET_TRIPLET=x64-windows-static -DBUILD_STATIC_LIBRARY=ON

build:
	@echo "Building project (Release)..."
	$(CMAKE) --build $(BUILD_DIR) --config $(BUILD_TYPE)
	@echo "Copying executable to repo root..."
	@copy /Y "$(BUILD_TYPE)\canary-map-editor.exe" "canary-map-editor.exe"

rebuild: clean configure build

debug:
	@echo "Configuring project (Debug)..."
	$(CMAKE) --preset windows-debug
	@echo "Building project (Debug)..."
	$(CMAKE) --build --preset windows-debug

clean:
	@echo "Cleaning build directory..."
	-rm -rf build/

run:
	@echo "Running application..."
	@if not exist "canary-map-editor.exe" (
		echo Error: canary-map-editor.exe not found. Run 'make build' first.
	) else (
		.\canary-map-editor.exe
	)
