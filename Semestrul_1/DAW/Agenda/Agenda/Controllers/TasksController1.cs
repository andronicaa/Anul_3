using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    public class TasksController1 : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
