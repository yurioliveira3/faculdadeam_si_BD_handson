CREATE OR REPLACE FUNCTION "validate_email" (email TEXT) RETURNS BOOL
LANGUAGE plpgsql AS
$function$
	BEGIN
    RETURN email ~ '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$';
  END;
$function$;

CREATE OR REPLACE FUNCTION "validate_email_NFE" (email TEXT) RETURNS BOOL
LANGUAGE plpgsql AS
$function$
	DECLARE i SMALLINT DEFAULT 0;

	BEGIN
  	WHILE i <= char_count(email,',')
  	LOOP
  			CASE
  				WHEN validate_email(TRIM(connector.str_split(email,',',i + 1))) = FALSE THEN
  			 		RETURN FALSE;
  				ELSE 
  					NULL;
  			END CASE;
  		
  		i = i + 1;	
  
  	END LOOP;
  	
  	RETURN TRUE;
	
  END;
$function$;
