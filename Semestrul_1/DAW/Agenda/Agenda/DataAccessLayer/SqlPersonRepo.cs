using Agenda.Data;
using Agenda.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class SqlPersonRepo : IPersonRepo
    {
        private readonly ApplicationDbContext _ctx;

        // instanta a basei de date
        public SqlPersonRepo(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }


        public IEnumerable<Person> GetAllPersons()
        {
            return _ctx.Persons.Include(x => x.ContactInfo).ToList();
        }

        public Person GetPersonById(int? id)
        {
            return _ctx.Persons.Where(p => p.PersonId == id).Include(x => x.ContactInfo).FirstOrDefault();
        }

        public bool SaveChanges()
        {
            return (_ctx.SaveChanges() >= 0);
        }
        public void CreatePerson(Person prs)
        {
            if (prs == null)
            {
                throw new ArgumentNullException(nameof(prs));
            }

            _ctx.Persons.Add(prs);
        }

        public void DeletePerson(Person prs)
        {
            if (prs == null)
            {
                throw new ArgumentNullException(nameof(prs));

            }
            _ctx.Persons.Remove(prs);
            
        }
    }
}

