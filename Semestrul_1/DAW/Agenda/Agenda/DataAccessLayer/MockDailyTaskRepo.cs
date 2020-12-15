using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.DataAccessLayer
{
    public class MockDailyTaskRepo : IDailyTaskRepo
    {
        public void CreateDailyTask(DailyTask tsk)
        {
            throw new NotImplementedException();
        }

        public void DeleteDailyTask(DailyTask tsk)
        {
            throw new NotImplementedException();
        }

        public IEnumerable<DailyTask> GetAllTasks()
        {
            var tasks = new List<DailyTask>
            {
                new DailyTask{DailyTaskId = 0, TitluTask = "Tema la matematica", Prioritate = "Medie", Deadline = "13-12-2020"},
                new DailyTask{DailyTaskId = 1, TitluTask = "Tema la romana", Prioritate = "Medie", Deadline = "13-12-2020"},
                new DailyTask{DailyTaskId = 2, TitluTask = "Tema la engleza", Prioritate = "Medie", Deadline = "13-12-2020"}
            };
            return tasks;
        }

        public DailyTask GetTaskById(int id)
        {
            throw new NotImplementedException();
        }

        public bool SaveChanges()
        {
            throw new NotImplementedException();
        }

        public void UpdateDailyTask(DailyTask tsk)
        {
            throw new NotImplementedException();
        }
    }
}
