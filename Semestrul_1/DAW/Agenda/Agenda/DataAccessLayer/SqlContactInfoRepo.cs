using Agenda.Data;
using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class SqlContactInfoRepo : IContactInfoRepo
    {
        private readonly ApplicationDbContext _ctx;

        // instanta a basei de date
        public SqlContactInfoRepo(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }
        public void CreateContacInfo(ContactInfo ct)
        {
            if (ct == null)
            {
                throw new ArgumentNullException(nameof(ct));
            }

            _ctx.ContactInfos.Add(ct);
        }

        public bool SaveChanges()
        {
            return (_ctx.SaveChanges() >= 0);
        }
    }
}
