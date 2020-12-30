using Microsoft.AspNet.Identity;
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
    public class AppointmentsController : Controller
    {
        private ApplicationDbContext ctx = new ApplicationDbContext();

        public ActionResult Index()
        {
            IEnumerable<Appointment> apt = ctx.Appointments.ToList();
            return View(apt);
        }

        public ActionResult AppointmentDetails(int id)
        {
            // caut in baza de date item-ul cu id-ul corespunzator
            Appointment apt = ctx.Appointments.Find(id);
            return View(apt);
        }


        [Route("appointments/newapt")]
        public ActionResult NewApt()
        {
            Appointment apt = new Appointment();
            return View(apt);
        }
        
        [HttpPost]
        public ActionResult CreateApt(Appointment apt)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // caut utilizatorul curent
                    var userId = User.Identity.GetUserId();
                    // caut in baza de date persoana corespunzatoare utilizatorului curent
                    Person prs = ctx.Persons.Where(p => p.UserId == userId).FirstOrDefault();
                    apt.Person = prs;
                    ctx.Appointments.Add(apt);
                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Appointments");
                }
                return View("NewApt", apt);
            } catch(Exception e)
            {
                return View("NewApt", apt);
            }
        }

        [Route("appointments/editapt/{id}")]
        public ActionResult EditApt(int id)
        {
            // id-ul este al intalnirii
            // caut item-ul in baza de date
            Appointment apt = ctx.Appointments.Find(id);
            return View(apt);
        }

        [HttpPost]
        public ActionResult UpdateApt(int id, Appointment aptReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    // caut item ul in baza de date
                    var userId = User.Identity.GetUserId();
                    // caut in baza de date persoana corespunzatoare utilizatorului curent
                    Person prs = ctx.Persons.Where(p => p.UserId == userId).FirstOrDefault();

                    Appointment apt = ctx.Appointments.Find(id);
                    apt.AppointmentType = aptReq.AppointmentType;
                    apt.Adresa = aptReq.Adresa;
                    apt.Data = aptReq.Data;
                    apt.Persoane = aptReq.Persoane;
                    apt.Detalii = aptReq.Detalii;
                    apt.Person = prs;

                    ctx.SaveChanges();
                    return RedirectToAction("Index", "Appointments");
                }

                return View("EditApt/" + id, aptReq);
            } catch(Exception e)
            {
                return View("EditApt/" + id, aptReq);
            }
        }

        [HttpPost]
        public ActionResult DeleteApt(int id)
        {
            // caut item-ul in baza de date
            Appointment apt = ctx.Appointments.Find(id); 
            if (apt == null)
            {
                return HttpNotFound();
            }

            ctx.Appointments.Remove(apt);
            ctx.SaveChanges();
            return RedirectToAction("Index", "Appointments");
        }

        [Route("appointments/orderappointments")]
        public ActionResult OrderAppointments()
        {
            // se ordoneaza intalnirile dupa data si se afiseaza in aceasta ordine
            AppointmentViewModel aptVm = new AppointmentViewModel();
            IEnumerable<Appointment> aptList = ctx.Appointments.ToList();
            
            // vreau sa ordonez aceasta lista dupa data 
            IEnumerable<Appointment> aptListOrd = aptList.OrderBy(p => p.Data);
            aptVm.AppointmentsList = aptListOrd;
            return View(aptVm);
        }
    }
}