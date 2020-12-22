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
    public class PersonContactInfoViewModelsController : Controller
    {
       
        private ApplicationDbContext ctx = new ApplicationDbContext();
        // afisam toate persoanele din baza de date
        public ActionResult Index()
        {
            IEnumerable<Person> prs = ctx.Persons.Include("ContactInfo").ToList();
            return View(prs);
        }

        [Route("personcontactinfoviewmodels/details/{id}")]
        [HttpGet]
        public ActionResult Details(int id)
        {
            Person personById = ctx.Persons.Where(p => p.PersonId == id).FirstOrDefault();
            return View(personById);
        }

        [Route("personcontactinfoviewmodels/newperson")]
        [HttpGet]
        public ActionResult NewPerson()
        {

            PersonContactInfoViewModel pc = new PersonContactInfoViewModel();
            return View(pc);

        }


        [HttpPost]
        public ActionResult CreateNewPerson(PersonContactInfoViewModel pcv)
        {

            if (!ModelState.IsValid)
            {
                var modelErrors = new List<string>();
                foreach (var modelState in ModelState.Values)
                {
                    foreach (var modelError in modelState.Errors)
                    {
                        modelErrors.Add(modelError.ErrorMessage);
                    }
                }

                foreach (var item in modelErrors)
                {
                    System.Console.WriteLine(item);
                }

            }
            try
            {
                Person prs = new Person();
                // mapez datele
                prs.Nume = pcv.Person.Nume;
                prs.Prenume = pcv.Person.Prenume;
                // le adaug in baza de date
                var userId = User.Identity.GetUserId();
                // prs.User = (ApplicationUser)User.Identity;
                prs.User.Id = userId;
                ctx.Persons.Add(prs);
                // salvez modificarile
                ctx.SaveChanges();

                // obiect de tipul contact
                ContactInfo cti = new ContactInfo();
                // mapez datele
                cti.PersonRef = prs.PersonId;
                cti.Adresa = pcv.ContactInfo.Adresa;
                cti.NrTelefon = pcv.ContactInfo.NrTelefon;
                cti.Email = pcv.ContactInfo.Email;
                cti.CodPostal = pcv.ContactInfo.CodPostal;
                cti.Person = ctx.Persons.Where(p => p.PersonId == cti.PersonRef).FirstOrDefault(); ;

                ctx.ContactInfos.Add(cti);

                ctx.SaveChanges();
                return RedirectToAction("Index", "personcontactinfoviewmodels");
            } catch(Exception e)
            {
                return View("NewPerson", pcv);
            }
                
            





        }

        [Route("personcontactinfoviewmodels/editperson/{id}")]
        [HttpGet]
        public ActionResult EditPerson(int? id)
        {
            if (id.HasValue)
            {
                // trebuie sa gasesc persoana cu id-ul respectiv
                var prs = ctx.Persons.Where(p => p.PersonId == id).FirstOrDefault();
                if (prs == null)
                {
                    return HttpNotFound();
                }
                // si trimit acel obiect catre view
                Person person = new Person();
                person.PersonId = prs.PersonId;
                person.Nume = prs.Nume;
                person.Prenume = prs.Prenume;

                ContactInfo ct = new ContactInfo();
                ct.Adresa = prs.ContactInfo.Adresa;
                ct.NrTelefon = prs.ContactInfo.NrTelefon;
                ct.Email = prs.ContactInfo.Email;
                ct.CodPostal = prs.ContactInfo.CodPostal;
                PersonContactInfoViewModel pc = new PersonContactInfoViewModel
                {
                    Person = person,
                    ContactInfo = ct
                };

                return View(pc);
            }
            return HttpNotFound();
        }

        [HttpPost]
        public ActionResult UpdatePerson(int id, PersonContactInfoViewModel pcv)
        {
            if (!ModelState.IsValid)
            {
                var modelErrors = new List<string>();
                foreach (var modelState in ModelState.Values)
                {
                    foreach (var modelError in modelState.Errors)
                    {
                        modelErrors.Add(modelError.ErrorMessage);
                    }
                }

                foreach (var item in modelErrors)
                {
                    System.Console.WriteLine(item);
                }

            }
            try
            {
                // primesc de la view un obiect de tip viewmodel
                // trebuie sa mapez modificarile facute la Person si Contact
                // fac un obiect de tip Person
                // trebuie sa caut persoana cu id-ul dat
                Person prs = ctx.Persons.Where(p => p.PersonId == id).FirstOrDefault();
                // actualizez datele din bd
                prs.Nume = pcv.Person.Nume;
                prs.Prenume = pcv.Person.Prenume;

                // salvez modificarile

                // trebuie sa salvez si modificarile in contactInfo
                prs.ContactInfo.NrTelefon = pcv.ContactInfo.NrTelefon;
                prs.ContactInfo.Adresa = pcv.ContactInfo.Adresa;
                prs.ContactInfo.Email = pcv.ContactInfo.Email;
                prs.ContactInfo.CodPostal = pcv.ContactInfo.CodPostal;
                ctx.SaveChanges();
                return RedirectToAction("Index");
            } catch(Exception e)
            {
                return RedirectToAction("EditPerson/" + id, "personcontactinfoviewmodels");
            }

            


        }

        [Route("personcontactinfoviewmodels/deleteperson/{id}")]
        [HttpPost]
        public ActionResult DeletePerson(int id)
        {
            // cautam persoana
            Person prs = ctx.Persons.Where(p => p.PersonId == id).FirstOrDefault();
            if (prs == null)
            {
                return HttpNotFound();
            }
            
            ContactInfo cti = ctx.ContactInfos.Where(p => p.PersonRef == id).FirstOrDefault();
            ctx.ContactInfos.Remove(cti);
            ctx.Persons.Remove(prs);
            ctx.SaveChanges();
            return RedirectToAction("Index");
        }




    }
}