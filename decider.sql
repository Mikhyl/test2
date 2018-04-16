DECLARE

v_policy_no     NUMBER:= 55640697;
v_xnew          NUMBER;
v_ynew          NUMBER;
v_dupe          NUMBER;
v_ycount        NUMBER;    

BEGIN

    SELECT  COUNT(*)
    INTO    v_xnew
    FROM    agreement_line
    WHERE   policy_no   = v_policy_no
    AND     newest      = 'X';

    SELECT  COUNT(*)
    INTO    v_ynew
    FROM    policy
    WHERE   policy_no   = v_policy_no
    AND     newest      = 'Y';
    
    SELECT  COUNT(*)
    INTO    v_dupe
    FROM    policy
    WHERE   policy_no       = v_policy_no
    AND     policy_seq_no   = (SELECT   policy_seq_no
                               FROM    (SELECT  policy_seq_no, ROW_NUMBER() OVER(ORDER BY policy_seq_no DESC) AS row_num
                                        FROM    policy
                                        WHERE   policy_no = v_policy_no) 
                               WHERE    row_num = 3);
            
    SELECT  COUNT(*)
    INTO    v_ycount
    FROM    policy
    WHERE   policy_no   = v_policy_no
    AND     newest      = 'Y';

    IF v_xnew > 0 AND v_ynew = 2 THEN
        DBMS_OUTPUT.PUT_LINE('FIX 2');
    ELSIF v_dupe > 1 AND v_xnew < 1 THEN
        DBMS_OUTPUT.PUT_LINE('FIX 1');       
    ELSIF v_ycount = 1 THEN
        DBMS_OUTPUT.PUT_LINE('FIX 3');
    END IF;

END;
/

