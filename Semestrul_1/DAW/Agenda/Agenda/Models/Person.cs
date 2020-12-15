using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Person
    {
        public int PersonId { get; set; }
        public string Nume { get; set; }
        public string Prenume { get; set; }

        public string Adresa { get; set; }

        // retinem si alte informatii despre(Poate sa aiba mai multe numere de telefon sau email-uri)
        public ICollection<ContactInfo> ContactInfos { get; set; }
    }
}
