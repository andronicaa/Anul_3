using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Appointment
    {
        public int AppointmentId { get; set; }
        public string AppointmentType { get; set; }
        public string Data { get; set; }
        public string Adresa { get; set; }

        // o persoana poate avea mai multe intalniri, dar o intalnire apartine doar unei persoane
    }
}
