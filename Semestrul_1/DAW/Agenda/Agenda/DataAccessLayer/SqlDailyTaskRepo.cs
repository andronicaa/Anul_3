using Agenda.Data;
using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class SqlDailyTaskRepo : IDailyTaskRepo
    {
        private readonly ApplicationDbContext _ctx;

        // instanta a basei de date
        public SqlDailyTaskRepo(ApplicationDbContext ctx)
        {
            _ctx = ctx;
        }
        public IEnumerable<DailyTask> GetAllTasks()
        {
            return _ctx.DailyTasks.ToList();
        }
    }
}
