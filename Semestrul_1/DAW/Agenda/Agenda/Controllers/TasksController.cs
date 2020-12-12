using Agenda.DataAccessLayer;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    
    public class TasksController : Controller
    {
        private readonly IDailyTaskRepo _repository;

        // dep injection
        public TasksController(IDailyTaskRepo repository)
        {
            _repository = repository; 
        }
        public IActionResult Index()
        {
            var taskItems = _repository.GetAllTasks();
            return View(taskItems);
        }
    }
}
