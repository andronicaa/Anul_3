using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class ContactInfo
    {
        public int ContactInfoId { get; set; }
        public string NrTelefon { get; set; }
        public string Email { get; set; }
        public string Adresa { get; set; }
        public string CodPostal { get; set; }

        // one-to-one relation
        
        public int PersonRef { get; set; }
        public virtual Person Person { get; set; }
    }
}
