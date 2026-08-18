--RAC NOTE: utl_file does more than read/write/append, it also appears to be able to do file operations such as rename, copy, etc
select *
from all_directories

--copies this from google (of course, google code had errors)
--THIS IS A READ FROM FILE EXAMPLE (loops through the entire file to display contents
DECLARE
  l_file   UTL_FILE.FILE_TYPE;
  l_buffer VARCHAR2(32767);
BEGIN
  -- Open the file for reading ('r')
  l_file := UTL_FILE.FOPEN('EXT_TAB_DIR', 'movies_to_buy.txt', 'r');

  LOOP
    BEGIN
      -- Read a single line
      UTL_FILE.GET_LINE(l_file, l_buffer);
      DBMS_OUTPUT.PUT_LINE('Read: ' || l_buffer);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        EXIT; -- Exit loop at end of file
    END;
  end LOOP;

  UTL_FILE.FCLOSE(l_file);
END;

--utl_file creates a file and write into it --example below (taken from google, it worked on first try
DECLARE
  l_file UTL_FILE.FILE_TYPE;
BEGIN
  -- Open the file for writing ('w')
  -- Format: FOPEN('DIRECTORY_OBJECT_NAME', 'filename', 'mode')
  l_file := UTL_FILE.FOPEN('EXT_TAB_DIR', 'utl_file_test.txt', 'w');

  -- Write lines to the file
  UTL_FILE.PUT_LINE(l_file, 'Hello, this is the first line.');
  UTL_FILE.PUT_LINE(l_file, 'Generated at: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

  -- Close the file to save changes
  UTL_FILE.FCLOSE(l_file);
EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.IS_OPEN(l_file) THEN
       UTL_FILE.FCLOSE(l_file);
    END IF;
    RAISE;
END;


--append to existing file (taken from google, it worked on first try)
--i appended a new line to the new file I created in above step (no issues)
DECLARE
  v_file_handle  UTL_FILE.FILE_TYPE;
BEGIN
  -- Open the file in append mode ('a')
  -- Note: The directory name 'MY_DOC_DIR' must be an Oracle Directory Object in UPPERCASE
  v_file_handle := UTL_FILE.FOPEN('EXT_TAB_DIR', 'utl_file_test.txt', 'a');

  -- Write a new line to the end of the file
  UTL_FILE.PUT_LINE(v_file_handle, 'Appending this new line at: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));

  -- Close the file to save changes
  UTL_FILE.FCLOSE(v_file_handle);

EXCEPTION
  WHEN UTL_FILE.INVALID_OPERATION THEN
    DBMS_OUTPUT.PUT_LINE('Error: Invalid operation. Check file permissions or directory path.');
    IF UTL_FILE.IS_OPEN(v_file_handle) THEN
      UTL_FILE.FCLOSE(v_file_handle);
    END IF;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
    IF UTL_FILE.IS_OPEN(v_file_handle) THEN
      UTL_FILE.FCLOSE(v_file_handle);
    END IF;
END;
/
