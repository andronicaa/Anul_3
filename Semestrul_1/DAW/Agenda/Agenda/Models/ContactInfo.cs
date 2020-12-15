using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class ContactInfo
    {
        public int Id { get; set; }
        public string NrTelefon { get; set; }
        public string Email { get; set; }

        public int PersonId { get; set; }
        public virtual Person Person { get; set; }
    }
}
