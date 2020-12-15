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

        public void CreateDailyTask(DailyTask tsk)
        {
            if (tsk == null)
            {
                throw new ArgumentNullException(nameof(tsk));
            }

            _ctx.DailyTasks.Add(tsk);
        }

        public void DeleteDailyTask(DailyTask tsk)
        {
            if (tsk == null)
            {
                throw new ArgumentNullException(nameof(tsk));

            }
            _ctx.DailyTasks.Remove(tsk);
        }

        public IEnumerable<DailyTask> GetAllTasks()
        {
            return _ctx.DailyTasks.ToList();
        }

        public DailyTask GetTaskById(int id)
        {
            return _ctx.DailyTasks.FirstOrDefault(p => p.DailyTaskId == id);
        }

        public bool SaveChanges()
        {
            return (_ctx.SaveChanges() >= 0);
        }

        public void UpdateDailyTask(DailyTask tsk)
        {
            //
        }

    }
}
