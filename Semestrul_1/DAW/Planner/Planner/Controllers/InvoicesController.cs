using Planner.Models;
using Planner.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    [Authorize]
    public class InvoicesController : Controller
    {
        private ApplicationDbContext ctx = new ApplicationDbContext();


        // afisam toate facturile din baza de date
        [Route("invoices/index")]
        public ActionResult Index()
        {
            IEnumerable<Invoice> inv = ctx.Invoices.ToList();
            return View(inv);
        }


        // detaliile despre o factura cu un id dat
        [Route("invoices/details/{id}")]
        public ActionResult Details(int id)
        {
            // caut factura in baza de date cu id-ul dat
            Invoice invDet = ctx.Invoices.Find(id);
            return View(invDet);
        }


        // se adauga o noua factura in baza de date
        [Route("invoices/newinvoice")]
        [Authorize(Roles = "Admin")]
        public ActionResult NewInvoice()
        {
            Invoice inv = new Invoice();
            return View(inv);
        }


        // o factura poate fi adaugata in baza de date doar de catre Admin
        [HttpPost]
        public ActionResult CreateInvoice(Invoice inv)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    ctx.Invoices.Add(inv);
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Invoices");
                }
                return View("NewInvoice", inv);
            } catch (Exception e)
            {
                return View("NewInvoice", inv);
            }
        }


        // Daca user-ul curent este Admin => acesta poate modifica toate campurile facturii
        // Daca user-ul curent este Child => poate modifica doar campul de Status
        [Authorize(Roles = "Admin,Child")]
        public ActionResult EditInvoice(int id)
        {
            // caut in baza de date factura corespunzatoate id-ului
            Invoice inv = ctx.Invoices.Find(id);
            Invoice childInv = ctx.Invoices.Find(id);
            if (User.IsInRole("Admin"))
            {
                return View(inv);
            }
            
                return View(childInv);
            
        }


        
        [HttpPost]
        public ActionResult UpdateInvoice(int id, Invoice invReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                   
                        
                        Invoice inv = ctx.Invoices.Find(id);
                        inv.TipFactura = invReq.TipFactura;
                        inv.DataEmitere = invReq.DataEmitere;
                        inv.DataScadenta = invReq.DataScadenta;
                        inv.TotalPlata = invReq.TotalPlata;
                        inv.Status = invReq.Status;
               
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Invoices");
                }
                return View("EditInvoice/" + id, invReq);
            } catch (Exception e)
            {
                return View("EditInvoice/" + id, invReq);
            }
        }


        // o factura poate fi eliminata doar de catre Admin
        [HttpPost]
        [Authorize(Roles ="Admin")]
        public ActionResult DeleteInvoice(int id)
        {
            // caut factura in baza de date
            Invoice inv = ctx.Invoices.Find(id);

            ctx.Invoices.Remove(inv);
            ctx.SaveChanges();

            return RedirectToAction("Index", "Invoices");
        }


        // facturile ce trebuie platite in luna curenta pot fi vazute de ambele tipuri de utilizatori
        [Authorize(Roles = "Admin,Child")]
        public ActionResult TotalFacturiLunaCurenta()
        {
            // aflu care este luna curenta
            DateTime dataCurenta = DateTime.Now;
            int lunaCurenta = dataCurenta.Month;
            double totalPlata = 0;

            InvoiceViewModel inv = new InvoiceViewModel();
            // caut toate facturile din baza de date care au data scadenta in aceasta luna
            IEnumerable<Invoice> invoices = ctx.Invoices.Where(p => p.DataScadenta.Month == lunaCurenta).ToList();
            inv.Invoices = invoices;

            foreach (var item in invoices)
            {
                totalPlata = totalPlata + item.TotalPlata;
            }
            inv.TotalSuma = totalPlata;
            // le trimit catre un view
            return View(inv);


        }
    }
}