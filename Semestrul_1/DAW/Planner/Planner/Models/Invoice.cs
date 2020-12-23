using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace Planner.Models
{
    public class Invoice
    {
        public int InvoiceId { get; set; }
        
        [Required]
        public string TipFactura { get; set; }

        [Required]
        public string DataEmitere { get; set; }

        [Required]
        public string DataScadenta { get; set; }

        [Required]
        public double TotalPlata { get; set; }

        [Required]
        public Status Status { get; set; }

    }
    public enum Status
    {
        Neachitat,
        Achitat
    }
}