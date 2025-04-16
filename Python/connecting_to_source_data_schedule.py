import kagglehub
from kagglehub import KaggleDatasetAdapter

df = kagglehub.dataset_load(
    KaggleDatasetAdapter.PANDAS,
    f"khushikyad001/world-happiness-report",
    f"world_happiness_report.csv"
)

df.to_csv("world_happiness_report.csv", index=False)
