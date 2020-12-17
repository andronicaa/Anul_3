using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Product
    {
        public int ProductId { get; set; }
        public string Denumire { get; set; }
        public string Cantitate { get; set; }
        public string Descriere { get; set; }
    }
}
