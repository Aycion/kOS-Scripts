PARAMETER hoverHeight is 150.


LOCK STEERING TO R(0,0,-90) + HEADING(90,90).
SET talt TO hoverHeight.
RCS ON.

PRINT "TARGET ALTITUDE: " + talt AT(0,8).

LOCK P TO (talt - SHIP:ALTITUDE).
SET I TO 0.
SET D TO 0.
SET P0 TO P.

SET Kp TO 0.019.
SET Ki TO 0.004.
SET Kd TO 0.06.

LOCK dthrott TO Kp * P + Ki * I + Kd * D.
STAGE.
SET g TO SHIP:SENSORS:GRAV:MAG.
LOCK hoverthrott TO Ship:Mass * g / Ship:AvailableThrust.
SET thrott TO hoverthrott.
LOCK THROTTLE TO thrott.

SET t0 TO TIME:SECONDS.
UNTIL STAGE:LIQUIDFUEL < 0.1 {
   PRINT "ALTITUDE: " + SHIP:ALTITUDE AT(0,9).
   PRINT "thrott: " + thrott AT(0,10).
   SET dt TO TIME:SECONDS - t0.
   IF dt > 0 {
      SET I TO I + (P * dt).
      SET D TO (P - P0) / dt.
      SET thrott TO MAX(MIN(hoverthrott + dthrott, 1), 0).
      SET P0 TO P.
      SET t0 TO TIME:SECONDS.
   }
   WAIT 0.001.
}
