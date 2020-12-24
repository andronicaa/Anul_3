using Planner.Models.MyValidation;
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
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)]
        public DateTime DataEmitere { get; set; }

        [Required]
        [DateValidation]
        [DisplayFormat(DataFormatString = "{0:yyyy-MM-dd}", ApplyFormatInEditMode = true)]
        [DataType(DataType.Date)]
        public DateTime DataScadenta { get; set; }

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