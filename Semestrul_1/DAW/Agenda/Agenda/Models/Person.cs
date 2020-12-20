using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Person
    {
        
        public int PersonId { get; set; }
        [Required(ErrorMessage ="Camp obligatoriu")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Numele trebuie sa contina doar litere")]
        public string Nume { get; set; }
        [Required(ErrorMessage = "Camp obligatoriu")]
        [RegularExpression(@"^[a-zA-Z]+$", ErrorMessage = "Prenumele trebuie sa contina doar litere")]
        public string Prenume { get; set; }

        // one-to-one
        
        public virtual ContactInfo ContactInfo { get; set; }
        
    }
}
