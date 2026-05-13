PROGRAM PROG_Greenhouse_Irrigation
    VAR_INPUT
        DI_Start_Watering : BOOL; (* Manual Switch or Moisture Sensor trigger *)
        DI_Tank_Empty : BOOL;
    END_VAR
    VAR_OUTPUT
        DO_Pump_On : BOOL;
        Alarm : BOOL;
    END_VAR
    VAR
        WaterTimer : TON;
        WaterRequest : BOOL;
    END_VAR

    IF DI_Start_Watering THEN
       WaterRequest := TRUE;
    END_IF;

    Alarm := WaterRequest AND DI_Tank_Empty;

    WaterTimer(IN:= WaterRequest AND NOT DI_Tank_Empty, PT := T#10s);
 
    DO_Pump_On := WaterRequest AND NOT DI_Tank_Empty AND NOT WaterTimer.Q;

    IF WaterTimer.Q THEN
        WaterRequest := FALSE;
    END_IF;
END_PROGRAM

CONFIGURATION Config0
    RESOURCE Res0 ON PLC
        TASK task1_100ms(INTERVAL := T#100ms, PRIORITY := 1);
        PROGRAM PROG_Instance_Greenhouse_Irrigation WITH task1_100ms : PROG_Greenhouse_Irrigation;
    END_RESOURCE
END_CONFIGURATION