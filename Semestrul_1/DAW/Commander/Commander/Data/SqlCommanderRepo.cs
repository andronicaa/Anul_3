using Commander.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Commander.Data
{
    // implementation class using a DbContext
    public class SqlCommanderRepo : ICommanderRepo
    {
        private readonly CommanderContext _ctx;

        public SqlCommanderRepo(CommanderContext ctx)
        {
            _ctx = ctx;
        }

        public void CreateCommand(Command cmd)
        {
            if (cmd == null)
            {
                throw new ArgumentNullException(nameof(cmd));

            }
            _ctx.Commands.Add(cmd);
        }

        public IEnumerable<Command> GetAppCommands()
        {
            return _ctx.Commands.ToList();
        }

        public Command GetCommandById(int id)
        {
            return _ctx.Commands.FirstOrDefault(predicate => predicate.Id == id);
        }

        public bool SaveChanges()
        {
            return (_ctx.SaveChanges() >= 0);
        }

        public void UpdateCommand(Command cmd)
        {
            // Nothing
        }
    }
}
