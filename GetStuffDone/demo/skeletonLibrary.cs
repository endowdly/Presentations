namespace EWSGDemo
{
    using System;
    using System.Windows;

    public class DopplerStation
    {
        public Point Location;

        public static double Doppler(Point location, double speed)
        {
            var relativePolarAngle = GetRelativePolarAngle(location);
            var relativeVelocity = GetRelativeVelocity(speed, relativePolarAngle);
            // 2 * v_rel * Cos(polAngle_rel.Radians) * (1/c0);

        }

        private double GetRelativePolarAngle(Point toLocation)
        {
            var relativePolarPosition = Location - toLocation;
            return Math.Abs(
                   Math.Atan2(
                        (Location.X * relativePolarPosition.Y) - (relativePolarPosition.X * Location.Y),
                        (Location.X * relativePolarPosition.X) + (Location.Y * relativePolarPosition.Y)));
        }

        private double GetRelativeVelocity(double speed, double angle)
        {
            return speed * Math.Sin(angle);
        }
    }
}