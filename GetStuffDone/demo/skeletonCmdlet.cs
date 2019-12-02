namespace EWSGDemo
{
    using System;
    using System.Management.Automation;
    using System.Windows; 

    // Verb Categories:
    // VerbsCommon
    // VerbsCommunications
    // VerbsData
    // VerbsDiagnostic
    // VerbsLifecycle
    // VerbsOther
    // VerbsSecurity 
    [Cmdlet(VerbsCommon.Get, "Doppler")]
    public class MyCmdlet : Cmdlet
    {
        [Parameter(Mandatory = true)]
        public double X;

        [Parameter(Mandatory = true)]
        public double Y;

        [Parameter(ValueFromPipeline = true)]
        public Mover[] InputObject;

        /// <summary>
        /// Processes the pipleine object.
        /// </summary>

        private Point location;
        private DopplerStation station;

        protected override void BeginProcessing()
        {
            location = new Point(X, Y); 
        }

        protected override void ProcessRecord()
        { 
            // station = new DopplerStation(location);
            // var doppler = station.Doppler()
            WriteObject(doppler); 
        }
    }

}