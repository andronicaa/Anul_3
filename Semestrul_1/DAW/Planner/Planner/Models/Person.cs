using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class Person
    {
        public int PersonId { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Numele trebuie sa contina doar litere")]
        public string Nume { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Prenumele trebuie sa contina doar litere")]
        public string Prenume { get; set; }

        [Required]
        public string UserId { get; set; }
        [Required]
        public string UserName { get; set; }

        // one-to-one

        public virtual ContactInfo ContactInfo { get; set; }

        // many-to-one
        public IEnumerable<Appointment> Appointments { get; set; }




    }
}