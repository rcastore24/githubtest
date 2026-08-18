select *
from aq_user.my_queue_table;

DECLARE
    enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
    message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    message_handle     RAW(16);
    my_payload         my_message_type;
BEGIN
    my_payload := my_message_type(1, 'This is a test message.');

    DBMS_AQ.ENQUEUE(
        QUEUE_NAME => 'my_queue',
        ENQUEUE_OPTIONS => enqueue_options,
        MESSAGE_PROPERTIES => message_properties,
        PAYLOAD => my_payload,
        MSGID => message_handle
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Message enqueued with ID: ' || RAWTOHEX(message_handle));
END;
/


SET SERVEROUTPUT ON;
DECLARE
    dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
    message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
    message_handle     RAW(16);
    my_payload         my_message_type;
BEGIN
    dequeue_options.WAIT := DBMS_AQ.FOREVER; -- Wait indefinitely for a message

    DBMS_AQ.DEQUEUE(
        QUEUE_NAME => 'my_queue',
        DEQUEUE_OPTIONS => dequeue_options,
        MESSAGE_PROPERTIES => message_properties,
        PAYLOAD => my_payload,
        MSGID => message_handle
    );

    DBMS_OUTPUT.PUT_LINE('Dequeued Message ID: ' || my_payload.message_id);
    DBMS_OUTPUT.PUT_LINE('Dequeued Message Text: ' || my_payload.message_text);

    COMMIT;
END;
/


--BELOW ARE THE SETUP STEPS TO CREATE QUEUE/QUEUE TABLE, ETC.
--BELOW STEPS TAKEN FROM GOOGLE AI RESPONSE, THEY WORK

CONNECT / AS SYSDBA;
CREATE USER aq_user IDENTIFIED BY aq_user DEFAULT TABLESPACE users;
GRANT CONNECT TO aq_user;
GRANT RESOURCE TO aq_user; -- For creating tables and types
GRANT AQ_ADMINISTRATOR_ROLE TO aq_user;
GRANT AQ_USER_ROLE TO aq_user;
ALTER USER aq_user QUOTA UNLIMITED ON users;

CONNECT aq_user/aq_user;
CREATE OR REPLACE TYPE my_message_type AS OBJECT (
    message_id NUMBER,
    message_text VARCHAR2(200)
);
/

BEGIN
    DBMS_AQADM.CREATE_QUEUE_TABLE(
        QUEUE_TABLE => 'my_queue_table',
        QUEUE_PAYLOAD_TYPE => 'MY_MESSAGE_TYPE'
    );

    DBMS_AQADM.CREATE_QUEUE(
        QUEUE_NAME => 'my_queue',
        QUEUE_TABLE => 'my_queue_table'
    );

    DBMS_AQADM.START_QUEUE(
        QUEUE_NAME => 'my_queue'
    );
END;
/
