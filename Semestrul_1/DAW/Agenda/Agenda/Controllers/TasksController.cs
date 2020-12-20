using Agenda.DataAccessLayer;
using Agenda.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Agenda.Controllers
{
    [AllowAnonymous]
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
       
        public ActionResult DetaliiTask(int? id)
        {
            if (id.HasValue)
            {
                // il cautam in baza de date
                DailyTask task = _repository.GetTaskById((int)id);
                if (task != null)
                {
                    return View(task);
                }
                return NotFound();
            }
            return NotFound();
        }
        public ActionResult NewTask()
        {
            DailyTask tsk = new DailyTask();
            return View(tsk);
        }


        public ActionResult CreateTask(DailyTask tsk)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    _repository.CreateDailyTask(tsk);
                    _repository.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("NewTask", tsk);
            } catch(Exception e)
            {
                return View("NewTask", tsk);
            }
        }

        
        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                // cautam task-ul corespunzator in baza de date
                DailyTask tsk = _repository.GetTaskById((int)id);
                if (tsk == null)
                {
                    return NoContent();
                }
                return View(tsk);
            }
            return NoContent();
        }


        [HttpPost("update")]
        public ActionResult Update(int id, DailyTask taskReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DailyTask tsk = _repository.GetTaskById(taskReq.DailyTaskId);
                    tsk.TitluTask = taskReq.TitluTask;
                    tsk.Prioritate = taskReq.Prioritate;
                    tsk.Deadline = taskReq.Deadline;
                    tsk.Detalii = taskReq.Detalii;
                    _repository.UpdateDailyTask(tsk);
                    _repository.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("Edit", taskReq);
            } catch (Exception e)
            {
                return View("Edit", taskReq);
            }
           
        }

        [HttpPost]
        public ActionResult DeleteTask(int id)
        {
            var tsk = _repository.GetTaskById(id);
            if (tsk == null)
            {
                return NotFound();
            }
            _repository.DeleteDailyTask(tsk);
            _repository.SaveChanges();
            return RedirectToAction("Index");

        }


    }
}
