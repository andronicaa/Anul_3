using Agenda.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Agenda.DataAccessLayer
{
    public interface IDailyTaskRepo
    {
        // lista cu toate task-urile
        IEnumerable<DailyTask> GetAllTasks();
    }
}
