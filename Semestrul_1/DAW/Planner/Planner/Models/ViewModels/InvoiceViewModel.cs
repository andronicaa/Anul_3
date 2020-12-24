using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Planner.Models.ViewModels
{
    public class InvoiceViewModel
    {
        public IEnumerable<Invoice> Invoices { get; set; }
        public double TotalSuma { get; set; }
    }
}