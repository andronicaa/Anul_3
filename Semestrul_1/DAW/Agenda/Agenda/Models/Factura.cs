using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Models
{
    public class Factura
    {
        public int FacturaId { get; set; }
        public string TipFactura { get; set; }
        public string DataEmitere { get; set; }
        public string DataScadenta { get; set; }
        public string Status { get; set; }
    }
}
