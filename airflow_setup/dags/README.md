# Setting Up a Workflow in Apache Airflow


A first Apache Airflow pipeline: a simple ETL DAG with three tasks
(fetch, process, store), plus a second version that adds a data
validation step to show what happens when a task fails.

Built for the ALX Data Engineering programme (Sprint 3 — orchestration).

## What is orchestration?

Orchestration means coordinating many tasks: deciding what runs, in what
order, what waits for what, and what happens when something fails.

The key difference from a clock-based tool like Windows Task Scheduler:

- Task Scheduler: "run task B at 3:00 PM"
- Airflow: "run task B **when task A succeeds**"

With a clock trigger, if task A runs long or fails, task B still starts
at 3:00 PM and processes incomplete or missing data — usually without
raising any error. Airflow removes that whole class of problem.

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
  installed and running

Airflow itself does **not** need to be installed. It runs inside a
container, which already contains Linux, Python and Airflow.

## Project structure

```
airflow_setup/
├── dags/
│   ├── simple_dag.py              # 3 tasks, all succeed
│   └── simple_dag_2.py   # adds a validation task that fails
├── screenshots/
│   ├── dag_success.png
│   └── dag_validation_failed.png
├── reflection.md                  # answers to the exercise questions
└── README.md
```

## How to run

**1. Start Docker Desktop** and wait until it reports *Engine running*.
The `docker` command in the terminal is only a client — it talks to a
background service (the Docker daemon) that only exists while Docker
Desktop is open.

**2. From the `airflow_setup` folder, start the container:**

```powershell
docker run -d -p 8080:8080 --name airflow -e LOAD_EX=n -v "${PWD}/dags:/opt/airflow/dags" apache/airflow:2.11.0 standalone
```

What the flags do:

| Flag | Meaning |
|---|---|
| `-d` | run in the background (detached) |
| `-p 8080:8080` | connect port 8080 on the PC to port 8080 in the container |
| `--name airflow` | give the container a fixed name instead of a random one |
| `-v "${PWD}/dags:/opt/airflow/dags"` | link the local `dags` folder to the DAGs folder inside the container |
| `standalone` | the command Airflow runs: a single-machine dev setup |

The `-v` flag (a **volume**) is essential. Without it the container has
its own private `dags` folder and never sees the files saved on the PC.

**3. Get the login password:**

```powershell
docker logs airflow
```

Look for the line `Login with username: admin password: ...`. Standalone
mode generates a new random password the first time it starts — it is
*not* `admin`.

**4. Open** <http://localhost:8080> and log in.

**5. In the UI:** switch the DAG on with the toggle, then click ▶ to
trigger it manually, and open the **Graph** view to watch the tasks run.
Clicking any task box gives its own logs.

## Stopping and restarting

```powershell
docker stop airflow     # stop it (keeps the container and its history)
docker start airflow    # start it again later
```

## The DAGs

### `simple_dag.py` — the happy path

Three tasks following the ETL pattern:

- `fetch_data` — **Extract**
- `process_data` — **Transform**
- `store_data` — **Load**

Dependencies are declared with the `>>` operator, which means "then":

```python
fetch >> process >> store
```

`schedule_interval=None` means the DAG never runs on a clock — it only
runs when triggered manually. That is what the exercise wants.

### `simple_dag_2.py` — the failure path

Adds a validation task, placed **before** the steps it protects:

```python
fetch >> validate >> process >> store
```

Putting validation after `store` would be too late: the bad data would
already be written to the destination.

A task fails only when its Python function **raises an exception** —
printing an error message still counts as a success:

```python
def validate_data():
    rows = 0
    if rows == 0:
        raise ValueError("No data fetched")
    print("Validation passed")
```

Result when validation fails: `validate_data` is marked `failed`, and
`process_data` and `store_data` are marked `upstream_failed` — they did
not fail themselves, the task before them did, so Airflow never ran them.

Set `rows` to a non-zero value to see the pipeline succeed instead.

## Notes and gotchas

- **The version in the exercise brief does not exist.** The instructions
  say `apache/airflow:2.12.0`, but the 2.x line stopped at **2.11.0**.
  Requesting a tag that does not exist gives:
  `failed to resolve reference ... not found`.
- **Airflow 3 is available**, but it renamed `schedule_interval` to
  `schedule` and moved `PythonOperator` to a different import path, so
  the exercise code would need edits. 2.11.0 keeps it working as written.
- **The `dag_id` must be unique across all files**, not just the
  filename. Two DAGs sharing an ID behave unpredictably.
- **`RemovedInAirflow3Warning` messages in the logs are warnings, not
  errors.** They flag things that change in the next major version.
- **Standalone mode uses the `SequentialExecutor`**, which runs one task
  at a time. Parallel branches (`fetch >> [a, b]`) are still declared
  correctly but execute one after another.
- If a DAG has a syntax error, the UI shows a red **Broken DAG** banner
  at the top of the page with the Python error.
- The scheduler rescans the `dags` folder roughly every 30 seconds, so a
  saved file takes a few moments to appear.