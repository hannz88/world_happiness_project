import kagglehub
from kagglehub import KaggleDatasetAdapter
import os

version = int(os.environ["REPORT_VERSION"])

df = kagglehub.dataset_load(
    KaggleDatasetAdapter.PANDAS,
    f"khushikyad001/world-happiness-report/versions/{version}",
    f"world_happiness_report.csv"
)

df.to_csv(f"{version}-world_happiness_report.csv", index=False)

