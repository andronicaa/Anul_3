using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Agenda.DataAccessLayer
{
    public interface IDailyTaskRepo
    {
        bool SaveChanges();
        // lista cu toate task-urile
        IEnumerable<DailyTask> GetAllTasks();

        // cautam in baza de date task-ul cu un id dat
        DailyTask GetTaskById(int id);
        void CreateDailyTask(DailyTask tsk);
        void UpdateDailyTask(DailyTask tsk);
        void DeleteDailyTask(DailyTask tsk);
         
    }
}
