using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public interface IContactInfoRepo
    {
        bool SaveChanges();
        void CreateContacInfo(ContactInfo ct);
    }
}
