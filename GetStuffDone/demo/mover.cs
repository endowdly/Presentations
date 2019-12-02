namespace EWSGDemo 
{
    using System.Drawing;

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