# After the specs have finished

if [ $SPECS_RESULT == 0 ]; then
  rake codecov:upload
fi