namespace EWSGDemo 
{
    using System.Windows;
    public struct Mover
    {
        public readonly Point Location;
        public readonly double Speed;

        public Mover(Point location, double speed)
        {
            Location = location;
            Speed = speed;
        } 
    }
}