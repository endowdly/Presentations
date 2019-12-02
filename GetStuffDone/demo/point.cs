namespace EWSGDemo 
{
    public struct Point
    { 
        public double X { get; set; }
        public double Y { get; set; }

        public Point(double x, double y) : this()
        {
            X = x;
            Y = y;
        }

        public static Point operator +(Point pointA, Point pointB)
        {
            return new Point((pointA.X + pointB.X), (pointA.Y + pointB.Y));
        }

        public static Point operator -(Point pointA, Point pointB)
        {
            return new Point((pointA.X - pointB.X), (pointA.Y - pointB.Y));
        }
    }
}