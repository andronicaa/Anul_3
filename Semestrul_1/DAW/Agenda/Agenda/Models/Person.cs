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
        public string Nume { get; set; }
        public string Prenume { get; set; }

        // one-to-one
        [Required]
        public virtual ContactInfo ContactInfo { get; set; }
    }
}
