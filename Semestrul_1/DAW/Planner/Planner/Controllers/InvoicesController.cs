using Planner.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    public class InvoicesController : Controller
    {
        private ApplicationDbContext ctx = new ApplicationDbContext();
        public ActionResult Index()
        {
            IEnumerable<Invoice> inv = ctx.Invoices.ToList();
            return View(inv);
        }

        [Route("invoices/details/{id}")]
        public ActionResult Details(int id)
        {
            // caut factura in baza de date cu id-ul dat
            Invoice invDet = ctx.Invoices.Find(id);
            return View(invDet);
        }

        [Route("invoices/newinvoice")]
        public ActionResult NewInvoice()
        {
            Invoice inv = new Invoice();
            return View(inv);
        }

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

        public ActionResult EditInvoice(int id)
        {
            // caut in baza de date
            Invoice inv = ctx.Invoices.Find(id);
            return View(inv);
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


        [HttpPost]
        public ActionResult DeleteInvoice(int id)
        {
            // caut factura in baza de date
            Invoice inv = ctx.Invoices.Find(id);

            ctx.Invoices.Remove(inv);
            ctx.SaveChanges();

            return RedirectToAction("Index", "Invoices");
        }
    }
}