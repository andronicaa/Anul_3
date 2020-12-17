using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public interface IPersonRepo
    {
        bool SaveChanges();
        IEnumerable<Person> GetAllPersons();
        Person GetPersonById(int? id);
        void CreatePerson(Person prs);
        void DeletePerson(Person prs);
        
    }
}
