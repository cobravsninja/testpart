	DECLARE
		_from text;
		_to text;
		_part text;
		_i int;
    BEGIN
		SELECT INTO _from date_trunc('MONTH',now() + INTERVAL '1 MONTH')::date;
		SELECT INTO _to (date_trunc('MONTH',now() + INTERVAL '1 MONTH')::date + interval '1 month - 1 day')::date;
		SELECT INTO _part 'life_requests' || replace(date_trunc('MONTH',now() + INTERVAL '1 MONTH')::date::text,'-','');
		EXECUTE 'CREATE TABLE ' || _part || ' PARTITION OF life_requests FOR VALUES FROM (''' ||
			_from || ''') TO (''' || _to || ''') PARTITION BY LIST (sub_nn)';
		FOR i IN 1..20 LOOP
			EXECUTE 'CREATE TABLE ' || _part || 's' || i || ' PARTITION OF ' || _part || ' FOR VALUES IN (' || i || ')';
		END LOOP;
	END;
