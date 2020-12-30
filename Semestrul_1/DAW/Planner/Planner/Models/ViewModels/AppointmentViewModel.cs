using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Planner.Models.ViewModels
{
    public class AppointmentViewModel
    {
        public IEnumerable<Appointment> AppointmentsList { get; set; }
    }
}