using Planner.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace Planner.Controllers
{
    [AllowAnonymous]
    public class DailyTasksController : Controller
    {
        private ApplicationDbContext _ctx = new ApplicationDbContext();
        public ActionResult Index()
        {
            // afisam toate task-urile din baza de date
            IEnumerable<DailyTask> taskList = _ctx.DailyTasks.ToList();
            return View(taskList);
        }

        public ActionResult DetaliiTask(int? id)
        {
            if (id.HasValue)
            {
                // il cautam in baza de date
                DailyTask task = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                if (task != null)
                {
                    return View(task);
                }
                return HttpNotFound("Nu exista cartea cu id-ul dat");
            }
            return HttpNotFound();
        }

        public ActionResult NewTask()
        {
            DailyTask tsk = new DailyTask();
            return View(tsk);
        }

        [HttpPost]
        public ActionResult CreateTask(DailyTask tsk)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    _ctx.DailyTasks.Add(tsk);
                    _ctx.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("NewTask", tsk);
            }
            catch (Exception e)
            {
                return View("NewTask", tsk);
            }
        }

        public ActionResult Edit(int? id)
        {
            if (id.HasValue)
            {
                // cautam task-ul corespunzator in baza de date
                DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                if (tsk == null)
                {
                    return HttpNotFound("Nu exista cartea cu id-ul dat");
                }
                return View(tsk);
            }
            return HttpNotFound();
        }

        [HttpPost]
        public ActionResult Update(int id, DailyTask taskReq)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
                    tsk.TitluTask = taskReq.TitluTask;
                    tsk.Prioritate = taskReq.Prioritate;
                    tsk.Deadline = taskReq.Deadline;
                    tsk.Detalii = taskReq.Detalii;

                    _ctx.SaveChanges();
                    return RedirectToAction("Index");
                }
                return View("Edit/" + id, taskReq);
            }
            catch (Exception e)
            {
                return View("Edit/" + id, taskReq);
            }

        }
        

        [HttpPost]
        public ActionResult DeleteTask(int id)
        {
            DailyTask tsk = _ctx.DailyTasks.FirstOrDefault(predicate => predicate.DailyTaskId == id);
            if (tsk == null)
            {
                return HttpNotFound();
            }
            _ctx.DailyTasks.Remove(tsk);
            _ctx.SaveChanges();
            return RedirectToAction("Index");

        }
    }
}