using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class Appointment
    {
        public int AppointmentId { get; set; }

        [Required]
        public string AppointmentType { get; set; }

        [Required]
        public string Data { get; set; }

        [Required]
        public string Adresa { get; set; }

        [Required]

        public string Persoane { get; set; }


        // o persoana poate avea mai multe intalniri, dar o intalnire apartine doar unei persoane
        
        
        public virtual Person Person { get; set; }
    }
}