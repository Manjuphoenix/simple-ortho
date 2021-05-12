@echo off
REM Preprocess NGI unrectified imagery for orthorectification with simple_ortho
REM 
REM Recompress with deflate to get around conda gdal's incompatibility with 12 bit jpegs and resample to be north up.
REM NOTE: Requires OSGeo4W with GDAL

if -%1-==-- call :printhelp & exit /b
echo File pattern: %1
echo.

if not defined OSGEO4W_ROOT (
echo OSGEO4W_ROOT does not exist - you need to install OSGEO4W with GDAL
exit /b
)

%%OSGEO4W_ROOT%%\osgeo4w.bat  REM setup environment for osgeo4w and support for 12bit jpegs

echo Recompressing....
setlocal EnableDelayedExpansion
for %%i in (%1) do (
echo "%%i":
REM echo %%~dpni_CMP.tif
gdal_translate -r bilinear -a_nodata 0 -co "TILED=YES" -co "COMPRESS=DEFLATE" -co "PREDICTOR=2" -co "NUM_THREADS=ALL_CPUS" -co "BLOCKXSIZE=512" -co "BLOCKYSIZE=512" "%%i" %%~dpni_CMP.tif && echo SUCCESS
)

goto :eof

:printhelp
echo.
echo Preprocess NGI unrectified imagery for simple_ortho (recompress and resample to N-up)
echo Requires OSGeo4W with GDAL
echo Usage: batch_recompress [file pattern]
echo    [file pattern]: A wildcard pattern matching .tif files to be recompressed, eg C:/dirName/*_RGBN.tif
goto :eof
