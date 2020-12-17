using Agenda.DataAccessLayer;
using Agenda.Models;
using Agenda.ViewModels;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    [AllowAnonymous]
    public class PersonContactViewModelsController : Controller
    {
        private readonly IPersonRepo _personRepo;
        private readonly IContactInfoRepo _contactRepo;

        // dep injection
        public PersonContactViewModelsController(IPersonRepo pRep, IContactInfoRepo cRep)
        {
            _personRepo = pRep;
            _contactRepo = cRep;

        }
        public IActionResult Index()
        {
            var person = _personRepo.GetAllPersons();
            return View(person);
        }

        [Route("personcontactviewmodels/details/{id}")]
        [HttpGet]
        public ActionResult Details(int id)
        {
            var personById = _personRepo.GetPersonById(id);
            return View(personById);
        }
        [HttpGet]
        public ActionResult NewPerson()
        {
           
            PersonContactViewModel pc = new PersonContactViewModel();
            
            return View(pc);

        }

        [HttpPost]
        public ActionResult CreateNewPerson(PersonContactViewModel pcv)
        {
            Person prs = new Person();
            // mapez datele
            prs.Nume = pcv.Person.Nume;
            prs.Prenume = pcv.Person.Prenume;
            // le adaug in baza de date
            _personRepo.CreatePerson(prs);
            // salvez modificarile
            _personRepo.SaveChanges();

            // obiect de tipul contact
            ContactInfo cti = new ContactInfo();
            // mapez datele
            cti.PersonRef = prs.PersonId;
            cti.Adresa = pcv.ContactInfo.Adresa;
            cti.NrTelefon = pcv.ContactInfo.NrTelefon;
            cti.Email = pcv.ContactInfo.Email;
            cti.CodPostal = pcv.ContactInfo.CodPostal;

            _contactRepo.CreateContacInfo(cti);

            _contactRepo.SaveChanges();
            return RedirectToAction("Index", "PersonContactViewModels");

        }

        [Route("personcontactviewmodels/editperson/{id}")]
        [HttpGet]
        public ActionResult EditPerson(int? id)
        {
            if (id.HasValue)
            {
                // trebuie sa gasesc persoana cu id-ul respectiv
                var prs = _personRepo.GetPersonById(id);
                if (prs == null)
                {
                    return NotFound();
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
                PersonContactViewModel pc = new PersonContactViewModel
                {
                    Person = person,
                    ContactInfo = ct
                };

                return View(pc);
            }
            return NotFound();
        }

        [HttpPost]
        public ActionResult UpdatePerson(int id, PersonContactViewModel pcv)
        {
            // primesc de la view un obiect de tip viewmodel
            // trebuie sa mapez modificarile facute la Person si Contact
            // fac un obiect de tip Person
            // trebuie sa caut persoana cu id-ul dat
            Person prs = _personRepo.GetPersonById(id);
            // actualizez datele din bd
            prs.Nume = pcv.Person.Nume;
            prs.Prenume = pcv.Person.Prenume;

            // salvez modificarile

            // trebuie sa salvez si modificarile in contactInfo
            prs.ContactInfo.NrTelefon = pcv.ContactInfo.NrTelefon;
            prs.ContactInfo.Adresa = pcv.ContactInfo.Adresa;
            prs.ContactInfo.Email = pcv.ContactInfo.Email;
            prs.ContactInfo.CodPostal = pcv.ContactInfo.CodPostal;
            _personRepo.SaveChanges();
            return RedirectToAction("Index");


        }

        [Route("personcontactviewmodels/deleteperson/{id}")]
        [HttpPost]
        public ActionResult DeletePerson(int id)
        {
            // cautam persoana
            Person prs = _personRepo.GetPersonById(id);
            if (prs == null)
            {
                return NotFound();
            }
            _personRepo.DeletePerson(prs);
            _personRepo.SaveChanges();
            return RedirectToAction("Index");
        }
        
        
    }
}

