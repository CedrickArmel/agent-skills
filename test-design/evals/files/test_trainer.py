# Sample test file with structural coupling — used for eval
import pytest
from myapp.trainer import ModelTrainer


class TestModelTrainer:
    def test_init(self):
        trainer = ModelTrainer(lr=0.01)
        assert trainer.lr == 0.01

    def test_build_optimizer(self):
        trainer = ModelTrainer(lr=0.01)
        opt = trainer._build_optimizer()
        assert opt is not None

    def test_run_epoch(self):
        trainer = ModelTrainer(lr=0.01)
        loss = trainer._run_epoch(fake_batch=[])
        assert isinstance(loss, float)

    def test_save_checkpoint(self):
        trainer = ModelTrainer(lr=0.01)
        trainer._save_checkpoint("/tmp/ckpt.pt")
        # no assertion, just checking it doesn't crash

    def test_fit(self):
        trainer = ModelTrainer(lr=0.01)
        result = trainer.fit(epochs=1, data=[])
        assert result is not None
